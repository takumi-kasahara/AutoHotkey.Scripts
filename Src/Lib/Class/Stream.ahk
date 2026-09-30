#Requires AutoHotkey v2.0

/**
 * @see {@link https://www.autohotkey.com/docs/v2/lib/For.htm}
 * @see {@link https://www.autohotkey.com/docs/v2/lib/Func.htm}
 */
class Stream
{
  /**
   * @constructor
   * @param {Array | Map | Gui | Object} enumerable
   */
  __New(enumerable)
  {
    if HasMethod(enumerable, "__Enum")
      this._enumerable := HasMethod(enumerable, "__Enum") ? enumerable : enumerable.OwnProps()
  }
  /**
   * @param {Func | BoundFunc} action
   */
  Each(action)
  {
    for key, value in this._enumerable
      if action.MinParams == 1 || action.MaxParams == 1
        action.Call(value)
      else if action.MinParams == 2
        action.Call(key, value)
      else if action.MinParams == 3
        action.Call(A_Index, key, value)
      else
        throw ValueError(Format("MinParams {} not implemented.", action.MinParams))
  }
  /**
   * @param {Func | BoundFunc} selector
   * @returns {Stream}
   */
  Map(selector)
  {
    result := Map()
    for key, value in this._enumerable
      if selector.MinParams == 1
        result.Set(key, selector.Call(value))
      else if selector.MinParams == 2
        result.Set(key, selector.Call(key, value))
      else if selector.MinParams == 3
        result.Set(key, selector.Call(A_Index, key, value))
      else
        throw ValueError(Format("MinParams {} not implemented.", selector.MinParams))
    return Stream(result)
  }
  /**
   * @param {Func | BoundFunc} filter
   * @returns {Stream}
   */
  Filter(filter)
  {
    result := Map()
    for key, value in this._enumerable
      if filter.MinParams == 1 || filter.MaxParams == 1
      {
        if filter(value)
          result.Set(key, value)
      }
      else if filter.MinParams == 2
      {
        if filter(key, value)
          result.Set(key, value)
      }
      else if filter.MinParams == 3
      {
        if filter(A_Index, key, value)
          result.Set(key, value)
      }
      else
        throw ValueError(Format("MinParams {} not implemented.", filter.MinParams))
    return Stream(result)
  }
  /**
   * @param {Func | BoundFunc} filter
   * @returns {Integer}
   */
  Some(filter)
  {
    for key, value in this._enumerable
      if filter.MinParams == 1 || filter.MaxParams == 1
      {
        if filter(value)
          return true
      }
      else if filter.MinParams == 2
      {
        if filter(key, value)
          return true
      }
      else if filter.MinParams == 3
      {
        if filter(A_Index, key, value)
          return true
      }
      else
        throw ValueError(Format("MinParams {} not implemented.", filter.MinParams))
    return false
  }
  /**
   * @param {Func | BoundFunc} filter
   * @returns {Integer}
   */
  Every(filter)
  {
    for key, value in this._enumerable
      if filter.MinParams == 1 || filter.MaxParams == 1
      {
        if !filter(value)
          return false
      }
      else if filter.MinParams == 2
      {
        if !filter(key, value)
          return false
      }
      else if filter.MinParams == 3
      {
        if !filter(A_Index, key, value)
          return false
      }
      else
        throw ValueError(Format("MinParams {} not implemented.", filter.MinParams))
    return true
  }
  /**
   * @param {Func | BoundFunc} accumulator
   * @param {Any} [init]
   * @returns {Any}
   */
  Reduce(accumulator, init?)
  {
    if IsSet(init)
      acc := init
    first := true
    for key, value in this._enumerable
    {
      if !IsSet(init) && first
      {
        acc := value
        first := false
        continue
      }
      first := false
      if accumulator.MinParams == 2
        acc := accumulator.Call(acc, value)
      else if accumulator.MinParams == 3
        acc := accumulator.Call(acc, key, value)
      else
        throw ValueError(Format("MinParams {} not implemented.", accumulator.MinParams))
    }
    return acc
  }
  /**
   * @param {String} [separator="`n"]
   * @returns {String}
   */
  Join(separator := "`n") => this.Reduce((acc, value) => acc == "" ? value : acc separator value, "")
  /**
   * @param {Func | BoundFunc} [selector]
   * @returns {Stream}
   */
  Reverse() => Stream(Array_Reverse(this.ToArray(selector?)))
  /**
   * @param {Func | BoundFunc} [selector]
   * @returns {Array}
   */
  ToArray(selector?)
  {
    if IsSet(selector)
      return this.Map(selector).ToArray()
    if this._enumerable is Array
      return this._enumerable
    result := []
    for key, value in this._enumerable
      result.Push(value)
    return result
  }
  /**
   * @param {Func | BoundFunc} [keySelector]
   * @param {Func | BoundFunc} [valueSelector]
   * @returns {Map}
   */
  ToMap(keySelector := (key, value) => key, valueSelector := (key, value) => value)
  {
    result := Map()
    for key, value in this._enumerable
    {
      if keySelector.MinParams == 1
        k := keySelector.Call(key)
      else if keySelector.MinParams == 2
        k := keySelector.Call(key, value)
      else if keySelector.MinParams == 3
        k := keySelector.Call(A_Index, key, value)
      else
        throw ValueError(Format("MinParams {} not implemented.", keySelector.MinParams))
      if valueSelector.MinParams == 1
        v := valueSelector.Call(value)
      else if valueSelector.MinParams == 2
        v := valueSelector.Call(key, value)
      else if valueSelector.MinParams == 3
        v := valueSelector.Call(A_Index, key, value)
      else
        throw ValueError(Format("MinParams {} not implemented.", valueSelector.MinParams))
      result.Set(k, v)
    }
    return result
  }
}
