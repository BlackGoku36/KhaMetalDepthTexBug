package;

import kha.Scheduler;
import kha.Framebuffer;

class App {

	public static var mesh:Mesh;

	var deltaTime:Float = 0.0;
	var totalFrames:Int = 0;
	var elapsedTime:Float = 0.0;
	var previousTime:Float = 0.0;
	var fps:Int = 0;

	static var onEndFrames: Array<Void->Void> = [];
	var shadow:Shadows;

	public function new() {
		mesh = new Mesh();
		mesh.load();
		TextureViewer.init();
		shadow = new Shadows();
	}

	public function update() {
		mesh.update();

		// trace('FPS: $fps');
		if (onEndFrames != null) for (endFrames in onEndFrames) endFrames();
	}

	public function render(g:Framebuffer) {
		var currentTime:Float = Scheduler.realTime();
		deltaTime = (currentTime - previousTime);

		elapsedTime += deltaTime;
		if (elapsedTime >= 1.0) {
			fps = totalFrames;
			totalFrames = 0;
			elapsedTime = 0;
		}
		totalFrames++;
		shadow.render(mesh);
		mesh.render(g.g4);

		if(shadow.map!=null){
			g.g4.begin();
			TextureViewer.render(g.g4, shadow.map, true, -1, 0.5, 0.5, 0.5);
			g.g4.end();
		}

		previousTime = currentTime;
	}


	public static function notifyOnEndFrame(func:Void->Void) {
		if (onEndFrames == null) onEndFrames = [];
		onEndFrames.push(func);
	}

}
