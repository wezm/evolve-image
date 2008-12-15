using GLib;
using Gee;

namespace Evolver {

	public class Point : Object {
		public int x { get; set; }
		public int y { get; set; }
	
		public string description() {
			return "%d %d".printf(x, y);
		}
	}

	public class Color : Object {
		public uchar r { get; set; }
		public uchar g { get; set; }
		public uchar b { get; set; }
		public uchar a { get; set; }
		
		public string description() {
			return "%d %d %d %lf".printf(r, g, b, (double)a / 255);
		}
	}

	public class Polygon : Object {
		public Color color { get; set; }
		public ArrayList<Point> points; // Make read only
		
		public Polygon(int num_points) {
			points = new ArrayList<Point> ();
			color = new Color();
			
			for(int i = 0; i < num_points; i++) {
				points.add(new Point());
			}
		}
		
		public string description() {
			StringBuilder b = new StringBuilder();
			b.append(color.description());
			foreach(Point point in points) {
				b.append_unichar(' ');
				b.append(point.description());
			}
			b.append_unichar('\n');
			
			return b.str;
		}
	}

	public class Dna : Object {
		
	}

	const int NUM_POINTS = 6;
	const int NUM_SHAPES = 50;
	const int NUM_THREADS = 8;

	public class Runner : Object {
	
		public static void main(string[] args) {
			Point p = new Point();
			p.x = 1;
			p.y = 2;
			stdout.printf("Point: %s\n", p.description());
			
			Color c = new Color();
			c.r = 127;
			c.g = 128;
			c.b = 129;
			c.a = 78;
			stdout.printf("Color: %s\n", c.description());
			
			Polygon poly = new Polygon(NUM_POINTS);
			stdout.printf("Polygon: %s", poly.description());
		}
	}

}