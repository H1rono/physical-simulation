abstract class Rigid {
    // id管理
    protected int id = 0;
    public int get_id() {
        return id;
    }

    public void set_id(int id) {
        this.id = id;
    }

    //! 中心座標
    public abstract PVector get_center();
    //! 並進運動の速度
    public abstract PVector get_velocity();
    //! 力積を加える
    public abstract void apply_impulse(PVector impulse);
    //! 質量
    public abstract float get_mass();
    //! 動くのかどうか
    public abstract boolean is_movable();
    //! ある点から剛体の周上までの最短経路ベクトル
    public abstract PVector touching_vector(PVector point);
    //! 点を含んでいるか
    public abstract boolean contains(float x, float y);
    public abstract boolean contains(PVector point);
    //! 他の剛体と衝突しているかどうか
    public abstract boolean is_collide(Rigid other);
    //! 他の剛体に与える影響を計算
    public abstract Effect effect_on(Rigid other, boolean new_collide);
    //! 影響を受ける
    public abstract void receive_effect(Effect effect);
    //! 反発係数の因子
    public abstract float repulsion_factor();
    //! 摩擦係数の因子
    public abstract float friction_factor();
    //! 時間経過
    public abstract void update(float delta_time);
    //! 描画
    public abstract void draw(PApplet applet);
}