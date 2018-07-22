import cell;
import std.stdio;
import std.array: array, split;
import std.conv;
import std.algorithm: map;

class Map
{
	private Cell[]   cells;
	private uint[][] data;
	private uint     _width;
	private uint     _height;

	this(uint w, uint h)
	{
		setDefaultCells();

		data = new uint[][h];
		foreach(ref line; data)
		{
			line = new uint[w];
		}

		_width  = w;
		_height = h;
	}

	this(string path)
	{
		setDefaultCells();

		File f = File(path, "r");

		foreach (line; f.byLine())
		{
			auto arr = line.split();
			data ~= arr.map!(x => x.to!uint).array;
		}

		_height = data.length;
		_width  = data[0].length;
	}

	const(Cell)* getCell(int x, int y)
	{
		return &cells[data[y][x]];
	}

	@property uint width()
	{
		return _width;
	}

	@property uint height()
	{
		return _height;
	}


	private void setDefaultCells()
	{
		cells = [
			Cell(CellType.empty, CellColor(0,0,32)), 
			Cell(CellType.solid, CellColor(128,128,128)),
			Cell(CellType.powder, CellColor(255,192,0))];
	}
}