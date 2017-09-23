
local package = package

package.preload["socket.socket"] 	= package.preload["socket"]
package.preload["socket.ltn12"] 	= package.preload["ltn12"]
package.preload["socket.mime"] 		= package.preload["mime"]

