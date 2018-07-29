import derelict.sdl2.sdl;
import std.container.dlist;
import std.exception;

enum EventType
{
	none          = 0,
	quitRequested = 1,
	keyPressed    = 2,
	buttonPressed = 4,
	windowExposed = 8
}

struct KeyPressedData
{
	SDL_Keycode key;
}

enum MouseButton
{
	left   = SDL_BUTTON_LEFT,
	right  = SDL_BUTTON_RIGHT,
	middle = SDL_BUTTON_MIDDLE
}

struct ButtonPressedData
{
	int         x;
	int         y;
	MouseButton button;
}

class Input
{
	private uint                    quitCount;
	private DList!KeyPressedData    keyQueue;
	private DList!ButtonPressedData clickQueue;
	private uint                    redrawCount;

	EventType waitEvent()
	{
		SDL_Event ev;

		while(true)
		{
			int st = SDL_WaitEvent(&ev);
			enforce(st == 1);

			EventType t = handleEvent(&ev);
			if (t != EventType.none) return t;
		}
	}

	bool wasQuitRequested()
	{
		if (quitCount == 0)
		{
			pollEvents();
		}
		
		return quitCount != 0;
	}

	void getQuitRequested()
	{
		enforce(quitCount > 0);

		quitCount--;
	}

	bool wasKeyPressed()
	{
		if (keyQueue.empty)
		{
			pollEvents();
		}
		
		return !keyQueue.empty;
	}

	KeyPressedData getKeyPressed()
	{
		enforce(!keyQueue.empty);

		KeyPressedData ret = keyQueue.front;
		keyQueue.removeFront();
		return ret;
	}

	bool wasButtonPressed()
	{
		if (clickQueue.empty)
		{
			pollEvents();
		}
		
		return !clickQueue.empty;
	}

	ButtonPressedData getButtonPressed()
	{
		enforce(!clickQueue.empty);

		ButtonPressedData ret = clickQueue.front;
		clickQueue.removeFront();
		return ret;
	}

	bool wasWindowExposed()
	{
		if (redrawCount == 0)
		{
			pollEvents();
		}

		return redrawCount != 0;
	}

	void getWindowExposed()
	{
		enforce(redrawCount > 0);

		redrawCount--;
	}

	private void pollEvents()
	{
		SDL_Event ev;

		while(SDL_PollEvent(&ev))
		{
			handleEvent(&ev);
		}
	}

	private EventType handleEvent(SDL_Event* ev)
	{
		if (ev.type == SDL_QUIT)
		{
			quitCount++;
			return EventType.quitRequested;
		}
		else if (ev.type == SDL_KEYDOWN)
		{
			keyQueue.insertBack(KeyPressedData(ev.key.keysym.sym));
			return EventType.keyPressed;
		}
		else if (ev.type == SDL_MOUSEBUTTONUP)
		{
			if (ev.button.button == SDL_BUTTON_LEFT || 
				ev.button.button == SDL_BUTTON_RIGHT ||
				ev.button.button == SDL_BUTTON_MIDDLE)
			{
				clickQueue.insertBack(ButtonPressedData(
					ev.button.x,
					ev.button.y,
					cast(MouseButton) ev.button.button));
				return EventType.buttonPressed;
			}		
		}
		else if (ev.type == SDL_WINDOWEVENT && 
			ev.window.event == SDL_WINDOWEVENT_EXPOSED)
		{
			redrawCount++;
			return EventType.windowExposed;
		}

		return EventType.none;
	}
}

