/** 剛体を表現する抽象クラス */
abstract class Rigid {
    /** id管理 */
    /** world内で区別するための識別子 */
    protected int id = 0;
    /**
     * 剛体のidを得る
     * @return 剛体のid
     */
    public int get_id() {
        return id;
    }

    /**
     * 剛体のidを設定する
     * @param id 設定するid
     */
    public void set_id(int id) {
        this.id = id;
    }

    /**
     * 剛体の中心座標を得る
     * @return 剛体の中心座標
     */
    public abstract PVector get_center();

    /**
     * 剛体の並進運動の速度を得る
     * @return 剛体の並進運動の速度
     */
    public abstract PVector get_velocity();

    /**
     * 力積を加える
     * @param 加える力積
     */
    public abstract void apply_impulse(PVector impulse);

    /**
     * 剛体の質量を得る
     * @return 剛体の質量
     */
    public abstract float get_mass();

    /**
     * 剛体が動くのかどうかを得る
     * @return 剛体が動くのかどうか
     */
    public abstract boolean is_movable();

    /**
     * ある点から剛体の周上までの最短経路ベクトルを得る
     * @param point 求めるベクトルの始点
     * @return 始点のベクトルに足すと剛体の周上に達するようなベクトルのうち、その大きさが最小となるもの
     */
    public abstract PVector touching_vector(PVector point);

    /**
     * 点を含んでいるかどうかを判定する
     * @param x 判定する点のx座標
     * @param y 判定する点のy座標
     * @return 点が剛体の周及び内部にあったらtrue, なければfalse
     */
    public abstract boolean contains(float x, float y);

    /**
     * 点を含んでいるかどうかを判定する
     * @param point 判定する点
     * @return 点が剛体の周及び内部にあったらtrue, なければfalse
     */
    public abstract boolean contains(PVector point);

    /**
     * 他の剛体と衝突しているかどうか判定する
     * @param other 判定対象の剛体
     * @return 対象の剛体と一点でも共有していたらtrue, 共有していなければfalse
     */
    public abstract boolean is_collide(Rigid other);

    /**
     * 他の剛体に与える影響を求める
     * @param other 影響を与える対象の剛体
     * @param new_collide 新たな衝突かどうか(前のフレームでも衝突していたらfalse)
     * @return 算出された影響
     */
    public abstract Effect effect_on(Rigid other, boolean new_collide);

    /**
     * 影響を受ける
     * @param effect 受ける影響
     */
    public abstract void receive_effect(Effect effect);

    /**
     * 剛体の反発係数の因子を得る
     * @return 剛体の反発係数の因子
     */
    public abstract float repulsion_factor();

    /**
     * 剛体の摩擦係数の因子を得る
     * @return 剛体の摩擦係数の因子
     */
    public abstract float friction_factor();

    /**
     * 時間経過で剛体を動かす
     * @param delta_time 経過時間
     */
    public abstract void update(float delta_time);

    /**
     * 剛体を描画する
     * @param applet 描画先のPApplet
     */
    public abstract void draw(PApplet applet);
}