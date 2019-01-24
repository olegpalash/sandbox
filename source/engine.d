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

				Cell c = _map[i, j];

				if (c.type == CellType.powder)
				{
					if (left())	
					{
						moveCell(i, j, powderVecL);
					}
					else
					{
						moveCell(i, j, powderVecR);
					}
				}
				else if (c.type == CellType.liquid)
				{
					if (left())	
					{
						moveCell(i, j, liquidVecL);
					}
					else
					{
						moveCell(i, j, liquidVecR);
					}
				}
			}
		}

		_t++;
	}

	private void moveCell(int i, int j, int[][] vec)
	{
		foreach (v; vec)
		{
			int ti = i+v[0];
			int tj = j+v[1];

			if (tj < 0 || tj >= _map.width)
			{
				continue;
			}

			Cell c = _map[i, j];

			if (displaces(c, _map[ti, tj]))
			{
				_map.swapCells(i, j, ti, tj);
				_used[ti][tj] = true;
				break;
			}
		}
	}

	private bool displaces(ref Cell c1, ref Cell c2)
	{
		if (c2.type == CellType.empty) 
		{
			return c1.type == CellType.powder ||
				c1.type == CellType.liquid;
		}
		else if (c2.type == CellType.liquid)
		{
			return c1.type == CellType.powder;
		}
		else
		{
			return false;
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

	private enum powderVecL = [[1, 0], [1, -1], [1,  1]];
	private enum powderVecR = [[1, 0], [1,  1], [1, -1]];
	private enum liquidVecL = powderVecL ~ [[0, -1], [0,  1]];
	private enum liquidVecR = powderVecR ~ [[0,  1], [0, -1]];
}
