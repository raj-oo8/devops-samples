using Microsoft.AspNetCore.Http;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.WebJobs.Extensions.SignalRService;
using System.Threading.Tasks;

namespace Azure.Functions
{
    public static class SignalRFunctions
    {
        private static int counter = 0;

        [FunctionName("negotiate")]
        public static SignalRConnectionInfo Negotiate(
            [HttpTrigger(AuthorizationLevel.Function, "post")] HttpRequest req,
            [SignalRConnectionInfo(HubName = "serverless")] SignalRConnectionInfo connectionInfo)
        {
            return connectionInfo;
        }

        [FunctionName("broadcast")]
        public static async Task Broadcast([TimerTrigger("*/5 * * * * *")] TimerInfo myTimer,
        [SignalR(HubName = "serverless")] IAsyncCollector<SignalRMessage> signalRMessages)
        {
            counter++;

            await signalRMessages.AddAsync(
                new SignalRMessage
                {
                    Target = "ReceiveCounter",
                    Arguments = [counter]
                });
        }

        [FunctionName("update")]
        public static void Update(
        [SignalRTrigger(hubName: "serverless", category: "messages", @event: "Update")] InvocationContext invocationContext)
        {
            var newCounterValue = (int)invocationContext.Arguments[0];
            counter = newCounterValue;
        }
    }
}