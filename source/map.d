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

	ref Cell getCell(int x, int y)
	{
		return data[y][x];
	}

	@property uint width()
	{
		return _width;
	}

	@property uint height()
	{
		return _height;
	}

	private void setDefaultMaterials()
	{
		materials = [
			Material(CellType.empty, CellColor(0,0,32)), 
			Material(CellType.solid, CellColor(128,128,128)),
			Material(CellType.powder, CellColor(255,192,0))];
	}
}
