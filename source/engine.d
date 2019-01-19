import map;
import cell;

class Engine
{
	private Map      _map;
	private uint     _t;
	private bool[][] _used;

	this(Map m)
	{
		_map  = m;
		_t    = 0;
		_used = new bool[][](m.height, m.width);
	}

	void update()
	{
		foreach(line; _used)
		{
			foreach(ref v; line)
			{
				v = false;
			}
		}

		for (int i = 0; i < _map.height-1; i++)
		{
			for (int j = 0; j < _map.width; j++)
			{
				if (_used[i][j]) continue;

				auto c = _map[i, j];

				if (c.type == CellType.powder)
				{
					if (_map[i+1, j].type == CellType.empty ||
						_map[i+1, j].type == CellType.liquid)
					{
						_map.swapCells(i, j, i+1, j);
						_used[i+1][j] = true;
					}
					else if (j > 0 && 
						left() &&
						(_map[i+1, j-1].type == CellType.empty ||
						 _map[i+1, j-1].type == CellType.liquid))
					{
						_map.swapCells(i, j, i+1, j-1);
						_used[i+1][j-1] = true;
					}
					else if (j < _map.width-1 && 
						right() &&
						(_map[i+1, j+1].type == CellType.empty ||
						 _map[i+1, j+1].type == CellType.liquid))
					{
						_map.swapCells(i, j, i+1, j+1);
						_used[i+1][j+1] = true;
					}
				}
				else if (c.type == CellType.liquid)
				{
					if (_map[i+1, j].type == CellType.empty)
					{
						_map.swapCells(i, j, i+1, j);
						_used[i+1][j] = true;
					}
					else if (j > 0 && 
						left() &&
						_map[i+1, j-1].type == CellType.empty)
					{
						_map.swapCells(i, j, i+1, j-1);
						_used[i+1][j-1] = true;
					}
					else if (j < _map.width-1 && 
						right() &&
						_map[i+1, j+1].type == CellType.empty)
					{
						_map.swapCells(i, j, i+1, j+1);
						_used[i+1][j+1] = true;
					}
					else if (j > 0 && 
						left() &&
						_map[i, j-1].type == CellType.empty)
					{
						_map.swapCells(i, j, i, j-1);
						_used[i][j-1] = true;
					}
					else if (j < _map.width-1 && 
						right() &&
						_map[i, j+1].type == CellType.empty)
					{
						_map.swapCells(i, j, i, j+1);
						_used[i][j+1] = true;
					}
				}
			}
		}

		_t++;
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
