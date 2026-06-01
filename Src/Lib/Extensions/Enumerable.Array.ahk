#Requires AutoHotkey v2.0

/**
 * @param {Array} a
 * @param {Array} b
 * @param {Func | BoundFunc} [comparer]
 * @returns {Integer}
 */
Array_Equal(a, b, comparer := (x, y) => x == y)
{
  if a.Length != b.Length
    return false
  for key, value in a
    if !b.Has(key) || !comparer.Call(value, b[key])
      return false
  return true
}
/**
 * @param {Array} array
 * @param {Any} value
 * @param {Func | BoundFunc} [comparer]
 * @returns {Boolean}
 */
Array_Contains(array, value, comparer := (x, y) => x == y)
{
  for item in array
    if comparer.Call(item, value)
      return true
  return false
}
/**
 * @param {Array} this
 * @returns {Array}
 */
Array_Reverse(this)
{
  reversed := []
  loop this.Length
    reversed.Push(this[-A_Index])
  return reversed
}
/**
 * @param {Array} this
 * @param {Integer} start
 * @param {Integer} [end]
 * @returns {Array}
 */
Array_Slice(this, start, end?)
{
  if start == 0
    throw ValueError("Start index cannot be zero.")
  if start < 0
    start := this.Length + start + 1

  if !IsSet(end)
    end := this.Length
  else if end < 0
    end := this.Length + end + 1

  if (Abs(start) > this.Length || Abs(end) > this.Length)
    throw ValueError("Start or end index is out of bounds.")
  if (start > end)
    throw ValueError("Start index must be less than or equal to end index.")
  sliced := []
  loop end - start + 1
    sliced.Push(this[start + A_Index - 1])
  return sliced
}
/**
 * @param {Array} this
 * @param {String} [separator="`n"]
 * @param {String} [options="CLogical"]
 * @param {Func | BoundFunc} [compare]
 * @returns {Array}
 */
Array_Sort(this, separator := "`n", options := "CLogical", compare?)
{
  joined := Enumerable_Join(this, separator)
  sorted := StrSplit(Sort(joined, options, compare?), separator)
  if this.Length > 0 && sorted.Length > 0 && this.Length !== sorted.Length
    throw ValueError("Length does not match.")
  return sorted
}
/**
 * @param {Array} this
 * @param {String} [separator="`n"]
 * @param {String} [options="CLogical"]
 * @param {Func | BoundFunc} [compare]
 * @returns {Array}
 */
Array_Unique(this, separator := "`n", options := "CLogical", compare?)
{
  prev := ""
  unique := []
  for value in Array_Sort(this, separator, options, compare?)
  {
    if value !== "" && prev == ""
      unique.Push(value)
    else if value !== "" && prev !== "" && value !== prev
      unique.Push(value)
    prev := value
  }
  return unique
}
/**
 * @param {Array*} arrays
 * @returns {Array}
 */
Array_Union(arrays*)
{
  union := []
  for a in arrays
    for value in a
      if !union.Has(value)
        union.Push(value)
  return union
}
/**
 * @param {Array} base
 * @param {Array*} others
 * @returns {Array}
 */
Array_Intersect(base, others*)
{
  if others.Length == 0
    return base
  intersect := []
  for v1 in base
  {
    all := true
    for a in others
      if !Array_Contains(a, v1)
      {
        all := false
        break
      }
    if all
      intersect.Push(v1)
  }
  return intersect
}
/**
 * @param {Array} base
 * @param {Array*} others
 * @returns {Array}
 */
Array_Except(base, others*)
{
  if others.Length == 0
    return base
  except := []
  for v1 in base
  {
    some := false
    for a in others
      if Array_Contains(a, v1)
      {
        some := true
        break
      }
    if !some
      except.Push(v1)
  }
  return except
}
