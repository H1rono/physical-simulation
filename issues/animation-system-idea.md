`PhysicalObj`インターフェースと`World`クラスを作り、各フレームの物理演算を`draw`関数本体から分離する案

- `PhysicalObj`は[#4](https://github.com/H1rono/physical-simulation/issues/4)の[このコミット](https://github.com/H1rono/physical-simulation/commit/7745ce1c0cc24a6e72ab92a136ef575fbc94dc93)の時点で各具象クラスが持つ関数をまとめる
- `World`は[#2](https://github.com/H1rono/physical-simulation/issues/2)を基にする

```processing
interface PhysicalObj {
    // 物体が持っている力を管理する
    public PVector get_force();
    public void set_force(PVector force);
    public void add_force(PVector force);

    public PVector get_velocity();
    public PVector get_center();
    public float get_mass();

    // pointから物体に到達するのに最も近いベクトルを計算する
    // pointが物体に含まれている場合は0ベクトルを返す
    public PVector closest_vector(PVector point);

    public boolean is_collide(PhysicalObj other);

    // otherとこの物体が衝突しているものとして、otherに与える影響(力と力積)を返す
    // 詳しくは #3 を参照
    // 反発係数と摩擦係数どうしよう...
    public Effect effect_on(PhysicalObj other);

    // 影響を受け取る
    // 名前がイマイチ
    public void add_effect(Effect effect);

    // delta_timeだけ時間を進める
    public void update(float delta_time);

    // 描画関数
    public void draw();
}
```

```processing
class World {
    // ここのコンストラクタで重力加速度、空気抵抗、1フレームで進む時間を設定する
    public World(PVector gravity, float air_resistance, float delta_time);

    // objを演算システムに登録する
    public void add_obj(PhysicalObj obj);

    // 登録したPhysicalObjの重力を再設定する
    public void reset_gravity();

    // 登録したPhysicalObjの衝突判定とその影響を計算
    // ここで重たい処理をやっつける
    public void calc_collide();

    // 時間を進める
    // 登録したPhysicalObjについて、空気抵抗を追加してからupdate(delta_time)を呼ぶ
    public void update();

    // 描画
    // 登録したPhysicalObjのdraw()を呼ぶ
    public void draw();
}
```