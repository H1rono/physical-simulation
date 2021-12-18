import java.util.List;
import java.util.ArrayList;

class World {
    /** シミュレーションする剛体のリスト */
    private List<Rigid> rigids;
    /** 現在生じている影響 */
    private List<Effect> effects;
    /** 重力加速度 */
    private PVector gravity;

    /**
     * Worldオブジェクトを作成する
     * @param gravity 重力加速度
     */
    public World(PVector gravity) {
        this.gravity = gravity;
        rigids = new ArrayList<Rigid>();
        effects = new ArrayList<Effect>();
    }

    /**
     * 剛体を追加する
     * @param rigid 追加する剛体
     */
    public void add_element(Rigid rigid) {
        rigid.set_id(rigids.size());
        rigids.add(rigid);
    }

    /**
     * 外力を計算する
     * @param delta_time 経過時間
     * @note 現在は重力以外に外力がないが、そのうち増やしたい
     */
    private void calculate_external_forces(float delta_time) {
        PVector delta_vel = PVector.mult(gravity, delta_time);
        for (Rigid rigid : rigids) {
            rigid.apply_impulse(PVector.mult(delta_vel, rigid.get_mass()));
        }
    }

    /**
     * 影響が現在生じているかを確かめる
     * @param provider_id 影響を与える剛体のid
     * @param receiver_id 影響を受ける剛体のid
     * @return effects内にproviderのidとreceiverのidが一致するEffectオブジェクトがあればtrue, なければfalse
     */
    public boolean contain_effect(int provider_id, int receiver_id) {
        // 線形探索ではなく二分探索にしたい
        for (Effect effect : effects) {
            if (effect.provider.get_id() == provider_id && effect.receiver.get_id() == receiver_id) {
                return true;
            }
        }
        return false;
    }

    /** 生じている影響のリストを更新する */
    private void update_effects() {
        List<Effect> new_effects = new ArrayList<Effect>();
        int rigids_num = rigids.size();
        for (int i = 0;     i < rigids_num - 1; i++)
        for (int j = i + 1; j < rigids_num;     j++) {
            Rigid rigid_i = rigids.get(i), rigid_j = rigids.get(j);
            if (rigid_i.is_collide(rigid_j)) {
                boolean contain = contain_effect(j, i);
                new_effects.add(rigid_j.effect_on(rigid_i, !contain));
            }
            if (rigid_i.is_collide(rigid_j)) {
                boolean contain = contain_effect(i, j);
                new_effects.add(rigid_i.effect_on(rigid_j, !contain));
            }
        }
        effects.clear();
        effects = new_effects;
    }

    /** 影響を働かせる */
    private void realize_effects() {
        for (Effect effect : effects) {
            //System.out.println(effect);
            effect.realize();
        }
    }

    /**
     * 剛体を運動させる
     * @param delta_time 経過時間
     */
    private void update_elements(float delta_time) {
        for (Rigid rigid : rigids) {
            rigid.update(delta_time);
        }
    }

    /**
     * シミュレーションの1サイクル
     * @details 外力 -> 剛体間の影響 -> 剛体の運動 の順に計算
     */
    public void update(float delta_time) {
        calculate_external_forces(delta_time);
        update_effects();
        realize_effects();
        update_elements(delta_time);
    }

    /**
     * 描画
     * @param applet 描画先のPApplet
     */
    public void draw(PApplet applet) {
        for (Rigid rigid : rigids) {
            rigid.draw(applet);
        }
    }
}