-module(view).
-include_lib("nitrogen_core/include/wf.hrl").
-include("records.hrl").
-compile(export_all).

main() -> #template{file="./priv/templates/slideshow.html"}.

filename() ->
	wf:url_decode(wf:path_info()).

title() ->
	filename().

slides() ->
	Filename = filename() ++ ".markdown",
	Slides = slideshow:get(Filename),
	draw_slides(Slides).

draw_slides(Slides) ->
	[draw_slide(Slide) || Slide <- Slides].

draw_slide(Slide) ->
	#section{data_fields=[markdown],body=[
		<<"<script type='text/template'>">>,
		wf:html_encode(Slide),
		<<"</script>">>
	]}.

