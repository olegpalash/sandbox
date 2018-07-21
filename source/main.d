import derelict.sdl2.sdl;
import graphics;
import map;

int main(string[] args)
{
	if (args.length > 1)
	{
		auto m = new Map(args[1]);
	}

	auto window = new Window("Sandbox", 800, 600);
	
	SDL_Delay(1000);

	return 0;
}
