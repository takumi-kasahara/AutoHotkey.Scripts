#Requires AutoHotkey v2.0

/**
 * @param {Any} expected
 * @param {Any} actual
 */
Assert_AreEqual(expected, actual, comparer := (x, y) => x == y)
{
  if !comparer(expected, actual)
    throw Error("Expected:" expected ", Actual:" actual)
}
/**
 * @param {Any} notExpected
 * @param {Any} actual
 */
Assert_AreNotEqual(notExpected, actual, comparer := (x, y) => x == y)
{
  if comparer(notExpected, actual)
    throw Error("NotExpected:" notExpected)
}
/**
 * @param {Integer | Float} value
 */
Assert_IsPositive(value)
{
  if value <= 0
    throw Error("Value:" value " is not positive.")
}
/**
 * @param {Integer | Float} value
 */
Assert_IsNegative(value)
{
  if value >= 0
    throw Error("Value:" value " is not negative.")
}
/**
 * @param {Integer} value
 */
Assert_IsTrue(value) => Assert_AreEqual(true, value)
/**
 * @param {Integer} value
 */
Assert_IsFalse(value) => Assert_AreEqual(false, value)
/**
 * @param {Func | BoundFunc} fn
 * @param {Object} cls
 */
Assert_Throws(fn, cls)
{
  try
    fn.Call()
  catch as ex
    Assert_IsTrue(ex is cls)
}
