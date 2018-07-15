import derelict.sdl2.sdl;
import std.string;
import std.exception;

static this()
{
	if (SDL_WasInit(SDL_INIT_VIDEO) == 0)
	{
		int status = SDL_Init(SDL_INIT_VIDEO);
		enforce(status == 0);
	}
}

static ~this()
{
	SDL_Quit();
}

class Window
{
	private SDL_Window*   window;
	private SDL_Renderer* renderer;
	private int           width;
	private int           height;

	public this(string title, int w, int h)
	{
		window = SDL_CreateWindow(
			title.toStringz,
			SDL_WINDOWPOS_CENTERED,
			SDL_WINDOWPOS_CENTERED,
			w,
			h,
			cast(SDL_WindowFlags) 0);

		enforce(window);

		renderer = SDL_CreateRenderer(
			window,
			-1,
			cast(SDL_RendererFlags) 0);
		
		enforce(renderer);

		width  = w;
		height = h;
	}

	public ~this()
	{
		SDL_DestroyRenderer(renderer);
		SDL_DestroyWindow(window);
	}
}
