using System.Net;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Logging;

public static class SignalRFunctions
{
    private static int counter = 0;

    [Function("negotiate")]
    public static async Task<HttpResponseData> Negotiate(
        [HttpTrigger(AuthorizationLevel.Anonymous, "post")] HttpRequestData req,
        [SignalRConnectionInfoInput(HubName = "serverless")] Task<string> connectionInfoTask)
    {
        var connectionInfo = await connectionInfoTask;
        var response = req.CreateResponse(HttpStatusCode.OK);
        response.Headers.Add("Content-Type", "application/json");
        await response.WriteStringAsync(connectionInfo);
        return response;
    }

    [Function("broadcast")]
    [SignalROutput(HubName = "serverless")]
    public static async Task<SignalRMessageAction> Broadcast([TimerTrigger("*/1 * * * * *")] TimerInfo timerInfo, FunctionContext context)
    {
        var logger = context.GetLogger("Broadcast");
        logger.LogInformation($"Broadcasting message at: {DateTime.Now}");

        counter++; // Increment the counter

        return await Task.FromResult(new SignalRMessageAction("ReceiveCount", new object[] { counter }));
    }
}