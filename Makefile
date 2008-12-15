all:
	valac --pkg gee-1.0 -X -I${HOME}/Local/vala/include/gee-1.0 -X -L${HOME}/Local/vala/lib -X -lgee -o evolve evolve.vala