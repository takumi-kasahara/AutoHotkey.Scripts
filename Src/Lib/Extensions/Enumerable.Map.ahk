#Requires AutoHotkey v2.0

/**
 * @param {Map} a
 * @param {Map} b
 * @param {BoundFunc | Function} [comparer]
 * @returns {Integer}
 */
Map_Equal(a, b, comparer := (x, y) => x == y)
{
  if a.Count != b.Count
    return false
  for key, value in a
    if !b.Has(key) || !comparer.Call(value, b[key])
      return false
  return true
}
/**
 * @param {Map} this
 * @returns {Map}
 */
Map_Keys(this)
{
  keys := []
  for key, value in this
    keys.Push(key)
  return keys
}
/**
 * @param {Map} this
 * @returns {Map}
 */
Map_Values(this)
{
  values := []
  for key, value in this
    values.Push(value)
  return values
}
/**
 * @param {Map*} maps
 * @returns {Map}
 */
Map_Union(maps*)
{
  union := Map()
  for m in maps
    for key, value in m
      if !union.Has(key)
        union.Set(key, value)
  return union
}
/**
 * @param {Map} base
 * @param {Map*} others
 * @returns {Map}
 */
Map_Intersect(base, others*)
{
  if others.Length == 0
    return Map()
  intersect := Map()
  for key, value in base
  {
    all := true
    for m in others
    {
      if !m.Has(key)
      {
        all := false
        break
      }
    }
    if all
      intersect.Set(key, value)
  }
  return intersect
}
/**
 * @param {Map} base
 * @param {Map*} others
 * @returns {Map}
 */
Map_Except(base, others*)
{
  if others.Length == 0
    return base
  except := Map()
  for key, value in base
  {
    some := false
    for m in others
    {
      if m.Has(key)
      {
        some := true
        break
      }
    }
    if !some
      except.Set(key, value)
  }
  return except
}
