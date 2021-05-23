import java.util.List;
import java.util.ArrayList;

class World {
    private List<PhysicalObj> objects;
    private PVector gravity;
    private float air_resistance, delta_time;

    // ここのコンストラクタで重力加速度、空気抵抗、1フレームで進む時間を設定する
    public World(PVector _gravity, float _air_resistance, float _delta_time) {
        objects = new ArrayList<PhysicalObj>();
        gravity = new PVector(0, 0);
        gravity.set(_gravity);
        air_resistance = _air_resistance;
        delta_time = _delta_time;
    }

    // objを演算システムに登録する
    public void add_obj(PhysicalObj obj) {
        objects.add(obj);
    }

    // 登録したPhysicalObjの重力を再設定する
    public void reset_gravity() {
        for (PhysicalObj obj : objects) {
            float mass = obj.get_mass();
            obj.set_force(gravity.copy().mult(mass));
        }
    }

    // 登録したPhysicalObjの衝突判定とその影響を計算
    // ここで重たい処理をやっつける
    public void calc_collide() {
        int obj_num = objects.size();
        for (int i = 0; i < obj_num - 1; ++i)
        for (int j = i + 1; j < obj_num; ++j) {
            PhysicalObj obj_i = objects.get(i), obj_j = objects.get(j);
            Effect effect_i2j, effect_j2i;
            if (obj_i.is_collide(obj_j)) {
                // obj_iはobj_jに接触している
                // => obj_iはobj_jから影響を受ける
                effect_j2i = obj_j.effect_on(obj_i);
            } else {
                effect_j2i = new Effect();
            }
            if (obj_j.is_collide(obj_i)) {
                effect_i2j = obj_i.effect_on(obj_j);
            } else {
                effect_i2j = new Effect();
            }
            obj_i.add_effect(effect_j2i);
            obj_j.add_effect(effect_i2j);
        }
    }

    // 時間を進める
    // 登録したPhysicalObjについて、空気抵抗を追加してからupdate(delta_time)を呼ぶ
    public void update() {
        for (PhysicalObj obj : objects) {
            PVector air_force = obj.get_velocity().mult(-air_resistance);
            obj.add_force(air_force);
            obj.update(delta_time);
        }
    }

    // 描画
    // 登録したPhysicalObjのdraw()を呼ぶ
    public void draw() {
        for (PhysicalObj obj : objects) {
            obj.draw();
        }
    }
}
