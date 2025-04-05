using Microsoft.AspNetCore.Http;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.SignalRService;
using Microsoft.Azure.WebJobs.Extensions.Timers;
using NSubstitute;
using System.Reflection;

namespace Azure.Functions.Tests
{
    public class SignalRFunctionsUnitTests
    {
        //[Fact]
        //public void Negotiate_ReturnsConnectionInfo()
        //{
        //    // Arrange
        //    var mockHttpRequest = Substitute.For<HttpRequest>();
        //    var connectionInfo = new SignalRConnectionInfo { Url = "http://localhost", AccessToken = "token" };

        //    // Act
        //    var result = SignalRFunctions.Negotiate(mockHttpRequest, connectionInfo);

        //    // Assert
        //    Assert.Equal(connectionInfo, result);
        //}

        [Fact]
        public async Task Broadcast_SendsMessage()
        {
            // Arrange
            var mockCollector = Substitute.For<IAsyncCollector<SignalRMessage>>();
            var timerInfo = new TimerInfo(null, new ScheduleStatus(), false);

            // Act
            await SignalRFunctions.Broadcast(timerInfo, mockCollector);

            // Assert
            await mockCollector.Received(1).AddAsync(Arg.Is<SignalRMessage>(m => m.Target == "ReceiveCounter" && (int)m.Arguments[0] > 0));
        }

        [Fact]
        public void Update_UpdatesCounter()
        {
            // Arrange
            var invocationContext = new InvocationContext
            {
                Arguments = [10]
            };

            // Act
            SignalRFunctions.Update(invocationContext);

            // Assert
            // Use reflection to access the private static field 'counter'
            var counterField = typeof(SignalRFunctions).GetField("counter", BindingFlags.Static | BindingFlags.NonPublic);
            if (counterField != null)
            {
                var counterValue = counterField.GetValue(null) as int?;
                Assert.Equal(10, counterValue);
            }
            else
            {
                Assert.Fail("Counter field not found.");
            }
        }
    }
}
