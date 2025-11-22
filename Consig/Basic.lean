
structure Time where
  val : Float
-- deriving Repr, Inhabited, BEq, Ord  -- ??: Ord in lean
deriving Repr, Inhabited, BEq

structure Frequency where
  val : Float
deriving Repr, Inhabited, BEq

structure DiscreteSignal where
  data : Array Float
  fs : Float
  fs_pos : fs > 0
