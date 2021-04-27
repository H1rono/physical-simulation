import java.util.List;
import java.util.ArrayList;

/*
https://github.com/H1rono/physical-simulation/issues/2
物理オブジェクトを管理するクラス
- add_obj()でオブジェクトを追加
- reset_gravity()でオブジェクトに重力加速度を再設定
- calc_force()で力を計算
- move()でオブジェクトを動かす
- draw()で描画
*/
class World {
    final public PVector gravity;
    final public float air_resistance, delta_time;

    private List<Ball> objects;

    public World(PVector _gravity, float _air_resistance, float _delta_time) {
        gravity = _gravity;
        air_resistance = _air_resistance;
        delta_time = _delta_time;
        objects = new ArrayList<Ball>();
    }

    public void add_obj(Ball obj) {
        objects.add(obj);
    }

    public void reset_gravity() {
        for (Ball obj : objects) {
            obj.set_force(gravity.copy().mult(obj.mass));
        }
    }

    public void calc_force() {
        // 空気抵抗
        for (Ball obj : objects) {
            PVector vel = obj.velocity.copy();
            PVector res_force = vel.mult(-air_resistance); // 空気抵抗の力
            obj.add_force(res_force);
        }
    }

    public void move() {
        for (Ball obj : objects) {
            obj.update(delta_time);
        }
    }

    public void draw() {
        for (Ball obj : objects) {
            obj.draw();
        }
    }
}