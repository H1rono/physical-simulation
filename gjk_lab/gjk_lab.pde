/*
void draw_arrow(PVector begin, PVector end) {
    line(begin.x, begin.y, end.x, end.y);
    PVector axis = PVector.sub(end, begin).normalize();
    PVector normal = new PVector(axis.y, -axis.x);
    float d = begin.dist(end) / 5;
    axis.mult(-d);
    normal.mult(d);
    PVector p1 = PVector.add(axis, normal).add(end);
    PVector p2 = PVector.sub(axis, normal).add(end);
    triangle(end.x, end.y, p1.x, p1.y, p2.x, p2.y);
}
*/
//地面に物体を置いた時に振動する,消える,折り返す
//1フレームに何回も衝突を起こせない
//めり込み解消時のエネルギー配分がミスってる
//
//
//

World world;
Ball ball;
//Box box1;
Box box2;
ImmoveBox immoveBox;

void setup() {
    size(720, 720);
    world = new World(new PVector(0, 5));
    ball = new Ball(new PVector(170, 100),new PVector(0, 0), 50, 20);
    //box1 = new Box(new PVector(300, 440),new PVector(0, 0), 100, 60, 0 ,40);
    box2 = new Box(new PVector(400, 510),new PVector(0, 0), 400, 100, 0 ,50);
    immoveBox = new ImmoveBox(
        new PVector(width / 2, height - 100),
        3 * width, 100
    );
    world.add_element(ball);
    //world.add_element(box1);
    world.add_element(immoveBox);
    world.add_element(box2);
}

void draw() {
    background(255);
    world.update(0.05);
    world.draw();
}

boolean key_keeper;
void keyPressed() {
    if(key_keeper){
        noLoop();
    }else{
        loop();
    }
    key_keeper=!key_keeper;
}
void mousePressed(){frameRate(5);}
void mouseReleased(){frameRate(60);}
