import java.util.List;
import java.util.ArrayList;

class World {
    private List<Rigid> rigids;
    private List<Effect> effects;
    private PVector gravity;

    public World(PVector gravity) {
        this.gravity = gravity;
        rigids = new ArrayList<Rigid>();
        effects = new ArrayList<Effect>();
    }

    public void add_element(Rigid rigid) {
        rigid.set_id(rigids.size());
        rigids.add(rigid);
    }

    private void calculate_external_forces(float delta_time) {
        PVector delta_vel = PVector.mult(gravity, delta_time);
        for (Rigid rigid : rigids) {
            rigid.apply_impulse(PVector.mult(delta_vel, rigid.get_mass()));
        }
    }

    public boolean contain_effect(int provider_id, int receiver_id) {
        // 線形探索ではなく二分探索にしたい
        for (Effect effect : effects) {
            if (effect.provider.get_id() == provider_id && effect.receiver.get_id() == receiver_id) {
                return true;
            }
        }
        return false;
    }

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

    private void realize_effects() {
        for (Effect effect : effects) {
            //System.out.println(effect);
            effect.realize();
        }
    }

    private void update_elements(float delta_time) {
        for (Rigid rigid : rigids) {
            rigid.update(delta_time);
        }
    }

    public void update(float delta_time) {
        calculate_external_forces(delta_time);
        update_effects();
        realize_effects();
        update_elements(delta_time);
    }

    public void draw(PApplet applet) {
        for (Rigid rigid : rigids) {
            rigid.draw(applet);
        }
    }
}