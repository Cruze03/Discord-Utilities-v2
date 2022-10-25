#if defined _DiscordObject_included_
  #endinput
#endif
#define _DiscordObject_included_

/**
* Discord objects that has an unique snowflake inherits from this methodmap.
*/
methodmap DiscordObject < JSON_Object
{
	/**
	* Get unique snowflake for this object.
	*
	* @param output      Output buffer.
	* @param maxsize     Length of the buffer.
	* @return            True on success, false otherwise.
	*/
    public bool GetID(char[] output, int maxsize)
	{
		return this.GetString("id", output, maxsize);
	}
}