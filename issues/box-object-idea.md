「箱」を表現するクラス

```processing
class Box {
    public PVector position, velocity, accelaration;
    private PVector impulse;
    public float mass, w_len, h_len; // w_len: 横幅、h_len: 縦幅

    // 適当なコンストラクタ
    public Box();

    // 衝突判定の関数
    // いつか共通のinterfaceを作って一般化したい
    public boolean is_collide(Box box);
    public boolean is_collide(Ball ball);
    public boolean is_collide(Floor floor);

    // 「影響」の関数
    public Effect effect_on(Box box);
    public Effect effect_on(Ball ball);
    public Effect effect_on(Floor floor);

    public void add_effect(Effect effect);
    public void update(float delta_time);
    public void draw();
}
```

Effectについては [#3](https://github.com/H1rono/physical-simulation/issues/3) を参照
