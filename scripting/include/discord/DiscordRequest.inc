#if defined _DiscordRequest_included_
  #endinput
#endif
#define _DiscordRequest_included_

#include <SteamWorks>

public int OnHTTPRequestComplete(Handle request, bool failure, bool requestSuccessful, EHTTPStatusCode statuscode) { }

public int OnHTTPDataReceive(Handle request, bool failure, int offset, int statuscode)
{
	if(failure || (statuscode != 200 && statuscode != 204))
	{
		if(statuscode == 400)
		{
			SteamWorks_GetHTTPResponseBodyCallback(request, ReceivedData);
		}
		
		new DiscordException("OnHTTPDataReceive - Fail %i %i", failure, statuscode);
	}

	delete request;
}

static int ReceivedData(const char[] data)
{
	PrintToServer("[DISCORD-API]: %s", data);
}

methodmap DiscordRequest < Handle
{
	public DiscordRequest(const char[] url, EHTTPMethod method)
	{
		return view_as<DiscordRequest>(SteamWorks_CreateHTTPRequest(method, url));
	}

	public void SetJsonBody(JSON_Object obj)
	{
		static char jsonString[16384];
		jsonString = NULL_STRING;
		if(obj != null)
			json_encode(obj, jsonString, sizeof(jsonString), JSON_NONE);

		SteamWorks_SetHTTPRequestRawPostBody(this, "application/json; charset=UTF-8", jsonString, strlen(jsonString));
	}

	property int Timeout
	{
		public set(int timeout) { SteamWorks_SetHTTPRequestNetworkActivityTimeout(this, timeout); }
	}

	public void SetContentSize(const char[] size = "0")
	{
		SteamWorks_SetHTTPRequestHeaderValue(this, "Content-Length", size);
	}

	public void SetCallbacks(SteamWorksHTTPRequestCompleted OnComplete = INVALID_FUNCTION, SteamWorksHTTPHeadersReceived OnHeadersReceived = INVALID_FUNCTION, SteamWorksHTTPDataReceived OnDataReceived = INVALID_FUNCTION)
	{
		SteamWorks_SetHTTPCallbacks(this, OnComplete, OnHeadersReceived, OnDataReceived);
	}
	
	public void SetContextValue(any data1 = 0, any data2 = 0)
	{
		SteamWorks_SetHTTPRequestContextValue(this, data1, data2);
	}

	public void SetBot(DiscordBot __bot)
	{
		char szBuffer[256];
		char szToken[196];
		__bot.GetString("token", szToken, sizeof(szToken));
		FormatEx(szBuffer, sizeof(szBuffer), "Bot %s", szToken);
		SteamWorks_SetHTTPRequestHeaderValue(this, "Authorization", szBuffer);
	}

	public bool Send()
	{
		return SteamWorks_SendHTTPRequest(this);
	}
}