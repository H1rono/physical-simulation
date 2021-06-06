import java.util.List;
import java.util.ArrayList;
import java.util.ListIterator;

class World {
    private List<Rigid> elements;
    private PVector gravity;

    public World(PVector gravity) {
        elements = new ArrayList<Rigid>();
        this.gravity = new PVector();
        this.gravity.set(gravity);
    }

    public void add_element(Rigid element) {
        elements.add(element);
    }

    public void check_collision() {
        int length = elements.size();
        for (int i = 0; i < length - 1; ++i)
        for (int j = i + 1; j < length; ++j) {
            Rigid rigid_i = elements.get(i), rigid_j = elements.get(j);
            if (!rigid_i.aabb_collide(rigid_j)) { continue; }

        }
    }

    public void update(float delta_time) {
        for (Rigid rigid : elements) {
            rigid.update(delta_time);
        }
    }
}