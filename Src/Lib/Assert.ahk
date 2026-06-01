#Requires AutoHotkey v2.0

/**
 * @param {Any} expected
 * @param {Any} actual
 */
Assert_AreEqual(expected, actual, comparer := (x, y) => x == y)
{
  if comparer(expected, actual)
    Log_Trace(Format("Expected:{}", expected))
  else
    throw Error(Format("Expected:{},Actual:{}", expected, actual))
}
/**
 * @param {Any} notExpected
 * @param {Any} actual
 */
Assert_AreNotEqual(notExpected, actual, comparer := (x, y) => x == y)
{
  if comparer(notExpected, actual)
    throw Error(Format("NotExpected:{}", notExpected))
  else
    Log_Trace(Format("NotExpected:{},Actual:{}", notExpected, actual))
}
/**
 * @param {Integer | Float} value
 */
Assert_IsPositive(value)
{
  if value > 0
    Log_Trace(Format("Value:{} is positive.", value))
  else
    throw Error(Format("Value:{} is not positive.", value))
}
/**
 * @param {Integer | Float} value
 */
Assert_IsNegative(value)
{
  if value < 0
    Log_Trace(Format("Value:{} is negative.", value))
  else
    throw Error(Format("Value:{} is not negative.", value))
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
