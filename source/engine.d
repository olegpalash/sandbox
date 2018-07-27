import map;
import cell;

class Engine
{
	private Map  _map;
	private uint _t;

	this(Map m)
	{
		_map = m;
		_t   = 0;
	}

	void update()
	{
		for (int i = 0; i < _map.height-1; i++)
		{
			for (int j = 0; j < _map.width; j++)
			{
				auto c = _map[i, j];

				if (c.type == CellType.powder)
				{
					if (_map[i+1, j].type == CellType.empty)
					{
						_map.swapCells(i, j, i+1, j);
					}
					else if (j > 0 && 
						left() &&
						_map[i+1, j-1].type == CellType.empty)
					{
						_map.swapCells(i, j, i+1, j-1);
					}
					else if (j < _map.width-1 && 
						right() &&
						_map[i+1, j+1].type == CellType.empty)
					{
						_map.swapCells(i, j, i+1, j+1);
					}
				}
			}
		}
	}

	private bool left()
	{
		return _t%2 == 0;
	}

	private bool right()
	{
		return _t%2 != 0;
	}
}
