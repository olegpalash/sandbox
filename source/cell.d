enum CellType
{
	empty,
	solid,
	powder,
	liquid
}

struct CellColor
{
	ubyte r;
	ubyte g;
	ubyte b;
}

struct Material
{
	CellType  type;
	CellColor color;
}

struct Cell
{
	Material* material;
	alias material this;
}

