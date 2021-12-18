/** 剛体間で及ぼされる影響を表現するクラス */
class Effect {
    /** 影響を与える剛体 */
    public Rigid provider;
    /** 影響を受ける剛体 */
    public Rigid receiver;
    /** 影響として働く力積 */
    public PVector impulse;

    /**
     * Effectオブジェクトを作成する
     * @param provider 影響を与える剛体
     * @param receiver 影響を受ける剛体
     * @param impulse 働く力積
     */
    public Effect(Rigid provider, Rigid receiver, PVector impulse) {
        this.provider = provider;
        this.receiver = receiver;
        this.impulse = impulse;
    }

    /** 影響を実際に働かせる */
    public void realize() {
        receiver.receive_effect(this);
    }

    /**
     * 影響の文字列表現
     * @return Effect(providerのid, receiverのid, impulseの成分表示)
     */
    public String toString() {
        return "Effect(" + provider.get_id() + ", " + receiver.get_id() + ", " + impulse + ")";
    }
}