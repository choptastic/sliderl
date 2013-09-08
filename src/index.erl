-module(index).
-include_lib("nitrogen_core/include/wf.hrl").
-include("records.hrl").
-compile(export_all).

main() ->
	#template{file="./priv/templates/bare.html"}.

title() -> "Slideshows".

body() ->
	PerPage = 12,
	{Count, Body} = slidelist_body("", 1, PerPage),
	#paginate{
		id=slideshows,
		perpage=PerPage,
		tag=slideshows,
		body=Body,
		num_items=Count,
		perpage_options=[12,24,48]
	}.

slidelist_body(Search, Page, PerPage) ->
	Slideshows = slideshow:list(Search),
	Num = length(Slideshows),
	Start = (Page-1) * PerPage + 1,
	LimitedSlideshows = lists:sublist(Slideshows, Start, PerPage),
	Body = [slideshow_preview_and_link(SS) || SS <- LimitedSlideshows],
	{Num, Body}.

slideshow_preview_and_link({File, FirstSlide}) ->
	Filename = filename:rootname(filename:basename(File)),
	Url = "/view/" ++ Filename,
	Click = #event{type=click, actions=#redirect{url=Url}},
	#panel{class=slideshow_wrapper, actions=Click, body=[
		#link{class=slideshow_filename, text=Filename, url=Url},
		#panel{class=slideshow_preview,body=[
			markdown:conv(wf:to_list(FirstSlide))
		]}
	]}.

paginate_event(slideshows, Search, PerPage, Page) ->
	{Count, Body} = slidelist_body(Search, Page, PerPage),
	#paginate_event{
		items=Count,
		body=Body
	}.
