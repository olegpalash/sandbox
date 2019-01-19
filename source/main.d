import std.stdio;
import graphics;
import map;
import input;
import engine;
import cell;
import derelict.sdl2.sdl;

int main(string[] args)
{
	Map m;
	if (args.length == 1)
	{
		m = new Map(32, 24);
	}
	else
	{
		m = new Map(args[1]);
	}

	auto eng    = new Engine(m);
	auto window = new Window("Sandbox", 1024, 768);
	auto inp    = new Input();
	bool cont   = true;
	bool redraw = true;
	int  tp     = 2;

	while (cont)
	{
		if (redraw)
		{
			window.showMap(m, 0, 0, 32);
			redraw = false;
		}

		inp.waitEvent();
		if (inp.wasWindowExposed())
		{
			redraw = true;
			inp.getWindowExposed();
		}
		else if (inp.wasQuitRequested())
		{
			cont = false;
		}
		else if (inp.wasKeyPressed())	
		{
			auto k = inp.getKeyPressed().key;
			if (k == SDLK_0)
			{
				tp = 0;
			}
			else if (k == SDLK_1)
			{
				tp = 1;
			}
			else if (k == SDLK_2)
			{
				tp = 2;
			}
			else if (k == SDLK_3)
			{
				tp = 3;
			}
			else if (k == SDLK_SPACE)
			{
				eng.update();
				redraw = true;
			}
		}
		else if (inp.wasButtonPressed())
		{
			auto p = inp.getButtonPressed();

			int x = p.x/32;
			int y = p.y/32;

			m[y, x] = Cell(m.getMaterial(tp));
			redraw = true;
		}
	}	
	
	return 0;
}
