abstract class Rigid implements Convex, Drawable {
    private int id;

    //! 並進運動の速度を取得する
    public abstract PVector get_velocity();

    /**
     * 並進運動の速度を変更する
     * @param delta_velocity 速度差分
     */
    public abstract void add_velocity(PVector delta_velocity);

    /**
     * 指定した時間だけ剛体を等速直線運動させる
     * @param delta_time 運動させる(微小)時間 1/60を想定
     */
    public abstract void move(float delta_time);

    //! 剛体が動くのかどうか
    public abstract boolean is_movable();

    //! 質量を取得する
    public abstract float get_mass();

    //! 質量の逆数を取得する
    public float get_mass_inv() {
        return is_movable() ? 1 / get_mass() : 0;
    }

    //! 反発係数決定用の値
    public abstract float restitution_rate();

    //! 摩擦係数決定用の値
    public abstract float friction_rate();

    //! idゲッター
    public int get_id() {
        return id;
    }

    //! idセッター
    public void set_id(int id) {
        this.id = id;
    }
}
