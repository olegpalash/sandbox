import derelict.sdl2.sdl;
import graphics;
import map;

int main(string[] args)
{
	auto window = new Window("Sandbox", 800, 600);
	
	if (args.length > 1)
	{
		auto m = new Map(args[1]);
		window.showMap(m, 0, 0, 32);
	}

	SDL_Delay(5000);
	return 0;
}
