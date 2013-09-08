-module(slideshow).
-compile({no_auto_import,[get/1]}).
-export([
	list/0,
	list/1,
	get/1
]).

-type slide() :: iolist().

-spec path() -> string().
path() ->
	"./slideshows".

-spec list() -> [{Path :: string(), FirstSlide :: slide()}].
list() ->
	list("").

-spec list(Search :: string()) -> [{Path :: string(), FirstSlide :: slide()}].
list(Search) ->
	Dir = path(),
	Files = filelib:wildcard(filename:join(Dir,"*.markdown")),
	SearchBin = list_to_binary(Search),
	Slides = [{File, extract_first_slide(File)}
		|| File <- Files, slides_contain(File, SearchBin)],
	Slides.

-spec get(Filename :: string()) -> Slides :: [slide()].
get(Filename) ->
	Dir = path(),
	SafeFilename = filename:basename(Filename),
	error_logger:info_msg("Opening file: ~p~n",[filename:join(Dir,SafeFilename)]),
	{ok, Bin} = file:read_file(filename:join(Dir,SafeFilename)),
	Slides = binary:split(Bin,<<"---\n">>,[global]),
	Slides.
	


slides_contain(_, <<>>) -> true;
slides_contain(Path, Search) ->
	{ok, FD} = file:open(Path, [read,binary]),
	Contain = slides_contain_worker(FD, Search),
	file:close(FD),
	Contain.

slides_contain_worker(FD, Search) ->
	case file:read_line(FD) of
		eof -> false;
		{ok, Line} ->
			case binary:match(Search, Line) of
				nomatch -> slides_contain_worker(FD, Search);
				_ -> true
			end
	end.


extract_first_slide(Path) ->
	error_logger:info_msg("Opening: ~p~n",[Path]),
	{ok, FD} = file:open(Path, [read, binary]),
	FirstSlide = read_until_line(FD, "---\n"),
	file:close(FD),
	FirstSlide.


read_until_line(FD, TargetLine) when is_list(TargetLine) ->
	read_until_line(FD, list_to_binary(TargetLine));
read_until_line(FD, TargetLine) when is_binary(TargetLine) ->
	case file:read_line(FD) of
		eof -> <<>>;
		{ok, TargetLine} -> <<>>;
		{ok, OtherLine} ->
			error_logger:info_msg("Line: ~p~n",[OtherLine]),
			RestOfSlide = read_until_line(FD, TargetLine),
			<<OtherLine/binary,RestOfSlide/binary>>
	end.
