package;

import kha.math.Matrix4;
import kha.Color;
import kha.Image;
import kha.Shaders;
// import scene.Scene;
import kha.math.FastVector3;
import kha.math.FastMatrix4;
import kha.graphics4.PipelineState;
import kha.graphics5_.TextureFormat;
import kha.graphics4.VertexStructure;
import kha.graphics4.ConstantLocation;

class Shadows {
    
    public var map: Image;
    var pipeline:PipelineState;
    var modelMatrixID:ConstantLocation;
    var mvpId:ConstantLocation;
    var mvp:FastMatrix4;
    public var shadowMVP:FastMatrix4;


    public function new() {
        var structure = new VertexStructure();
        structure.add("pos", Float3);

        map = Image.createRenderTarget(2048, 2048, TextureFormat.DEPTH16, Depth32Stencil8);
        pipeline = new PipelineState();
        pipeline.inputLayout = [structure];
        pipeline.vertexShader = Shaders.shadow_vert;
		pipeline.fragmentShader = Shaders.shadow_frag;
		pipeline.depthWrite = true;
        pipeline.depthMode = Less;
        pipeline.compile();
        
        mvpId = pipeline.getConstantLocation("mvp");

        var projection = FastMatrix4.orthogonalProjection(-10, 10, -10, 10, -10, 10);
        var viewMat = FastMatrix4.lookAt(new FastVector3(-8.962+5, 8.469-5, 9.285-5), new FastVector3(), new FastVector3(0, 0, 1));
        shadowMVP = projection.multmat(viewMat);
    }

    public function render(mesh:Mesh) {
        var g4 = map.g4;
        g4.begin();
        g4.clear(0xff00ffff, 1);
        g4.setPipeline(pipeline);
        mesh.setVIBuffers(g4);
        g4.setMatrix(mvpId, shadowMVP.multmat(FastMatrix4.fromMatrix4(Matrix4.identity())));
        mesh.drawVertices(g4);
        g4.end();
    }
}