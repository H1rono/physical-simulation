interface PhysicalObj {
    // 物体が持っている力を管理する
    public PVector get_force();
    public void set_force(PVector force);
    public void add_force(PVector force);

    public PVector get_velocity();

    // Floor実装中にいらないかもと思った
    public PVector get_center();

    public float get_mass();

    // pointから物体に接触するのに最も近いベクトルを計算する
    // pointが物体に含まれている場合は0ベクトルを返す
    public PVector contact_vector(float x, float y);
    public PVector contact_vector(PVector point);

    // 衝突判定
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
