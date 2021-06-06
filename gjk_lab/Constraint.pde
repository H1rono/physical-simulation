// 拘束条件
abstract class Constraint {
    abstract public Convex get_convex1();
    abstract public Convex get_convex2();
    abstract public PVector get_contact_normal();
}
