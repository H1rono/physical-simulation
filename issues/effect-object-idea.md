`effect_on()`メソッドを実装するのは？

草案:

```processing
// 略

void draw() {
    // 略
    if (ball.is_collide(floor)) {
        // Effectクラスは様々な力や力積による「影響」を表す
        // eはfloorからballへの「影響」
        Effect e = floor.effect_on(ball);
        ball.add_effect(e);
    }
    if (floor.is_collide(ball)) {
        // floorがballの「影響」を受け取る
        Effect e = ball.effect_on(floor);
        floor.add_effect(e);
    }
    // ここで「影響」を速度などに反映させる
    ball.update(delta_time);
    floor.update(delta_time);
    // 略
}
```

Effectクラス:

```processing
class Effect {
    // 力、力積
    // delta_timeが決定するまで力積から力は求まらないため、力積のみ別に持つ
    public PVector force, impulse;

    public Effect(PVector force, PVector impulse) {
        this.force = force
        this.impulse = impulse
    }
}
```