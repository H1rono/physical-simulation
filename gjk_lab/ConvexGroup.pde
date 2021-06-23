import java.util.List;
import java.util.ArrayList;
import java.util.ListIterator;

// 物体系
class ConvexGroup extends Convex {
    private List<Convex> convexes;

    public ConvexGroup() {
        convexes = new ArrayList<Convex>();
    }

    ListIterator<Convex> convex_iterator() {
        return convexes.listIterator();
    }

    public void add_convex(Convex cnv) {
        convexes.add(cnv);
    }

    @Override
    public float min_x() {
        if (convexes.size() == 0) { return 0; }
        ListIterator<Convex> iter = convexes.listIterator();
        float x = iter.next().min_x();
        while (iter.hasNext()) {
            x = min(x, iter.next().min_x());
        }
        return x;
    }
    @Override
    public float max_x() {
        if (convexes.size() == 0) { return 0; }
        ListIterator<Convex> iter = convexes.listIterator();
        float x = iter.next().max_x();
        while (iter.hasNext()) {
            x = max(x, iter.next().max_x());
        }
        return x;
    }
    @Override
    public float min_y() {
        if (convexes.size() == 0) { return 0; }
        ListIterator<Convex> iter = convexes.listIterator();
        float y = iter.next().min_y();
        while (iter.hasNext()) {
            y = min(y, iter.next().min_y());
        }
        return y;
    }
    @Override
    public float max_y() {
        if (convexes.size() == 0) { return 0; }
        ListIterator<Convex> iter = convexes.listIterator();
        float y = iter.next().max_y();
        while (iter.hasNext()) {
            y = max(y, iter.next().max_y());
        }
        return y;
    }

    @Override
    public PVector support(PVector point) {
        if (convexes.size() == 0) { return new PVector(0, 0); }
        ListIterator<Convex> iter = convexes.listIterator();
        Convex cnv = iter.next();
        PVector sup = cnv.support(point);
        float dot = sup.dot(point);
        while (iter.hasNext()) {
            cnv = iter.next();
            PVector n_sup = cnv.support(point);
            float n_dot = n_sup.dot(point);
            if (dot < n_dot) {
                sup = n_sup;
                dot = n_dot;
            }
        }
        return sup;
    }
}
