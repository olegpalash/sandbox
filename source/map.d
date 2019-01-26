import cell;
import std.stdio;
import std.array: array, split;
import std.conv;
import std.algorithm: map, swap;

class Map
{
	private Material[] materials;
	private Cell[][]   data;
	private uint       _width;
	private uint       _height;

	this(uint w, uint h)
	{
		setDefaultMaterials();

		data = new Cell[][h];
		foreach(ref line; data)
		{
			line = new Cell[w];
			foreach(ref c; line)
			{
				c.material = &materials[0];
			}
		}

		_width  = w;
		_height = h;
	}

	this(string path)
	{
		setDefaultMaterials();

		File f = File(path, "r");

		foreach (line; f.byLine())
		{
			auto   arr = line.split();
			Cell[] d;

			foreach (v; arr)
			{
				uint id = v.to!uint;
				auto mat = &materials[id];
				d ~= Cell(mat);
			}
			data ~= d;
		}

		_height = data.length;
		_width  = data[0].length;
	}

	void save(string path)
	{
		File f = File(path, "w");

		for (int i = 0; i < _height; i++)
		{
			for (int j = 0; j < _width; j++)
			{
				Material* m = data[i][j].material;

				bool found = false;

				for(int k = 0; k < materials.length; k++)
				{
					if (*m == materials[k])
					{
						f.write(k, ' ');
						found = true;
						break;
					}
				}

				if (!found) f.write(0, ' ');
			}

			f.writeln();
		}
	}

	deprecated ref Cell getCell(int x, int y)
	{
		return data[y][x];
	}

	void swapCells(uint i1, uint j1, uint i2, uint j2)
	{
		swap(data[i1][j1], data[i2][j2]);
	}

	ref Cell opIndex(uint i, uint j)
	{
		return data[i][j];
	}

	@property uint width()
	{
		return _width;
	}

	@property uint height()
	{
		return _height;
	}

	Material* getMaterial(uint id)
	{
		return &materials[id];
	}

	private void setDefaultMaterials()
	{
		materials = [
			Material(CellType.empty, CellColor(0,0,32)), 
			Material(CellType.solid, CellColor(128,128,128)),
			Material(CellType.powder, CellColor(255,192,0)),
			Material(CellType.liquid, CellColor(64,128,255))];
	}
}
