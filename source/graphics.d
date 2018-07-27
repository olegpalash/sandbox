import derelict.sdl2.sdl;
import std.string;
import std.exception;
import map;
import cell;

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

	public void showMap(Map mp, int offX, int offY, int sz)
	{
		SDL_RenderClear(renderer);

		int w = width/sz;
		int h = height/sz;

		for (int i = 0; i < h; i++)
		{
			int y = i+offY;
			if (y >= mp.height) break;
			if (y < 0) continue;

			for (int j = 0; j < w; j++)
			{
				int x = j+offX;
				if (x >= mp.width) break;
				if (x < 0) continue;

				auto c = mp.getCell(x, y).material.color;

				SDL_Rect r;
				r.x = j*sz;
				r.y = i*sz;
				r.w = r.h = sz;
			
				SDL_SetRenderDrawColor(renderer, c.r, c.g, c.b, 255);
				SDL_RenderFillRect(renderer, &r);
		
			}
		}
	
		SDL_RenderPresent(renderer);
	}
}
