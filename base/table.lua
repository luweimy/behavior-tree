--------------------------------------------------------------------------------
-- @module table
-- @desc 对table库的扩展
--------------------------------------------------------------------------------

local _G = _G
local table = table
local pairs = pairs

function table.copyitem(from, to)
  for k,v in pairs(from) do
    to[k]=v
  end
end

--------------------------------------------------------------------------------
-- 判断是否存在item为key的表项
--------------------------------------------------------------------------------
function table.isexist(t, item)
    return table.keyof(t, item) ~= nil
end

--------------------------------------------------------------------------------
-- 判断表是否为空(表不存在或表为空)
--------------------------------------------------------------------------------
function table.isempty(t)
    if nil == t then return true end
    return _G.next(t) == nil
end

--------------------------------------------------------------------------------
-- 获得表的第一项
--------------------------------------------------------------------------------
function table.firstpair(t)
    for k, v in pairs(t) do
        return k, v
    end
end

--------------------------------------------------------------------------------
-- 获得表的最后一项
--------------------------------------------------------------------------------
function table.lastpair(t)
    local count = 0
    for _, _ in pairs(t) do
        count = count + 1
    end
    return table.at(t, count)
end

--------------------------------------------------------------------------------
-- 获得表的最后一项
--------------------------------------------------------------------------------
function table.at(t, pos)
    local i = 0
    for k, v in pairs(t) do
        i = i + 1
        if i == pos then return k, v end
    end
end

--------------------------------------------------------------------------------
-- 将表中所有项置空
----------------------------------------------------------------------------------
function table.clear(t)
    for k,v in pairs(t) do
        t[k] = nil
    end
end

--------------------------------------------------------------------------------
-- prune: remove duplicates from a table
-- if a hash function is provided, it is used to produce a unique hash for each
-- element in the input table.
-- if a merge function is provided, it defines how duplicate entries are merged,
-- otherwise, a random entry is picked.
--------------------------------------------------------------------------------
function table.prune(tbl, hashfunc, merge)
   local hashes = {}
   local hash = hashfunc or function(a) return a end
   if merge then
      for i,v in ipairs(tbl) do
         if not hashes[hash(v)] then 
            hashes[hash(v)] = v
         else
            hashes[hash(v)] = merge(v, hashes[hash(v)])
         end
      end
   else
      for i,v in ipairs(tbl) do
         hashes[hash(v)] = v
      end
   end
   local ntbl = {}
   for _,v in pairs(hashes) do
      table.insert(ntbl, v)
   end
   return ntbl
end

function table.length(t)
    local cnt = 0
    for _ in pairs(t) do
        cnt = cnt + 1
    end
    return cnt
end

-- --------------------------------------------------------------------------------
-- 稳定排序 comp中必须是'<‘号时才是稳定的
-- --------------------------------------------------------------------------------
function table.ssort(array, comp)
  local comp = comp or function(a,b) return a<b end
  for i=1, #array do
      for j=1, #array-1 do
        if comp(array[j], array[j+1]) then
          array[j], array[j+1] = array[j+1], array[j]
        end
      end
  end
  return array
end

--------------------------------------------------------------------------------
-- 产生乱序的数
--------------------------------------------------------------------------------
function table.randomgenor(from, to)
  local randoms = {}
  for i=from,to do
    table.insert(randoms, i)
  end
  for i = 1, #randoms do
    local otheri = math.random(1,#randoms)
    randoms[i], randoms[otheri] = randoms[otheri], randoms[i]
  end
  return randoms
end

--------------------------------------------------------------------------------
-- splicing: remove elements from a table
--------------------------------------------------------------------------------
function table.splice(tbl, start, length)
   length = length or 1
   start = start or 1
   local endd = start + length
   local spliced = {}
   local remainder = {}
   for i,elt in ipairs(tbl) do
      if i < start or i >= endd then
         table.insert(spliced, elt)
      else
         table.insert(remainder, elt)
      end
   end
   return spliced, remainder
end


--------------------------------------------------------------------------------
-- 删除指定范围的值，并将后面的前移
-- @param: array - 数组
--         index - 要删除的起始坐标
--         length - 要删除的个数
--------------------------------------------------------------------------------
function table.removerange(array, index, length)
    local max = table.maxn(array)
    for i = index, max - length + 1 do
        array[i] = array[i + length]
        array[i + length] = nil
    end
end

--------------------------------------------------------------------------------
-- 收缩数组，将后面的元素向前移动，去掉数组中的nil
-- @param: array - 数组，数组的最大下标必须大于0
--         minindex - 最小下标
--------------------------------------------------------------------------------
function table.shrink(array, minindex)
    minindex = minindex or 1
    local maxIndex = table.maxn(array)
    local table_removerange = table.removerange
    for index = minindex, maxIndex do
        if nil == array[index] then
            local cursor = index
            while (nil == array[cursor + 1]) and (cursor + 1 <= maxIndex) do
                cursor = cursor + 1
            end
            -- index是nil的开始index，cursor代表连续的nil的结尾index
            local len = cursor - index + 1
            table_removerange(array, index, len, maxIndex)
            index = index - 1
            maxIndex = maxIndex - len
        end
    end
end