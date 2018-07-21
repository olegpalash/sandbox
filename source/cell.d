enum CellType
{
	empty,
	solid,
	powder
}

struct CellColor
{
	ubyte r;
	ubyte g;
	ubyte b;
}

struct Cell
{
	CellType  type;
	CellColor color;
}

