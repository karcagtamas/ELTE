package sample_2;

import org.junit.jupiter.api.Test;
import org.mockito.MockedConstruction;
import org.mockito.Mockito;

import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.util.Scanner;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.hasSize;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotEquals;
import static org.mockito.BDDMockito.given;
import static org.mockito.Mockito.*;

public class NetworkConnectionTest {

    NetworkConnection mNetworkConnection;

    /*@Before
    public void BlackMagic() throws UnsupportedEncodingException {
        mNetworkConnection = new NetworkConnection();
    }*/

    @Test
    public void HttpRequestReturnsNotNull() throws MalformedURLException, IOException {
        assertNotEquals(" ", mNetworkConnection.GetHttpRequest());
    }


    @Test
    public void HttpRequestReturnsNull() throws MalformedURLException, IOException {
        mNetworkConnection = mock(NetworkConnection.class);
        when(mNetworkConnection.GetHttpRequest()).thenReturn(" ");
        assertEquals(" ", mNetworkConnection.GetHttpRequest());
    }

    @Test //2nd task    
    public void HttpRequestReturnsNullWithFakeUrl() throws UnsupportedEncodingException, MalformedURLException, IOException {
        mNetworkConnection = mock(NetworkConnection.class);

        String vURL = "Dummy";

        URL vObjectURL = mock(URL.class);
        URLConnection vURLConnection = mock(URLConnection.class);

        String vCharset = "UTF-8";
        // when( vURLConnection.setRequestProperty("Accept-Charset", vCharset ) ).thenReturn(" ");
        when(vObjectURL.openConnection()).thenReturn(vURLConnection);

        when(mNetworkConnection.GetHttpRequestParameterized(vURL, vObjectURL)).thenReturn("not valid");

        String result = null;
        try {
            result = mNetworkConnection.GetHttpRequestParameterized(vURL, vObjectURL);
        } catch (MalformedURLException e) {
            assertEquals(result, "not valid");
        }
        assertEquals(result, "not valid");
    }

    @Test
    public void GetHttpRequestWithMockitoOld() throws IOException {
        final var mockStream = mock(InputStream.class, withSettings().useConstructor().defaultAnswer(CALLS_REAL_METHODS));

        final var mockUrl = mock(URL.class);
        final var mockConnect = mock(URLConnection.class, withSettings().useConstructor((URL) null).defaultAnswer(RETURNS_MOCKS));
        when(mockConnect.getInputStream()).thenReturn(mockStream);

        when(mockUrl.openConnection()).thenReturn(mockConnect);

        final var mockScanner = mock(Scanner.class, withSettings().defaultAnswer(RETURNS_MOCKS));
        when(mockScanner.useDelimiter("\\A").next()).thenReturn("HELLO");
    }

    @Test //1st approach Mockito
    public void GetHttpRequestWithMockito() throws IOException {
        InputStream vInputStreamMock = mock(InputStream.class, withSettings().useConstructor().defaultAnswer(CALLS_REAL_METHODS));

        URLConnection vURLConnectionMock = mock(URLConnection.class, withSettings().useConstructor().defaultAnswer(CALLS_REAL_METHODS));
        when(vURLConnectionMock.getInputStream()).thenReturn(vInputStreamMock);

        URL vURLmock = mock(URL.class);
        when(vURLmock.openConnection()).thenReturn(vURLConnectionMock);

        Scanner vScannerMock = mock(Scanner.class);
        when(vScannerMock.useDelimiter("\\A").next()).thenReturn("Abrakadabra.");
    }

    @Test
    public void GetHttpRequestWithMockitoLatest() throws IOException, MalformedURLException, UnsupportedEncodingException {
        NetworkConnection vNetworkConnection = new NetworkConnection();

        URLConnection vURLConnectionMock = mock(URLConnection.class, withSettings().useConstructor().defaultAnswer(CALLS_REAL_METHODS));

        try (MockedConstruction<URL> myobjectMockedConstruction = Mockito.mockConstruction(URL.class,
                (mock, context) -> {
                    given(mock.openConnection()).willReturn(vURLConnectionMock); //any additional mocking
                })) {
            vNetworkConnection.GetHttpRequest();
            assertThat(myobjectMockedConstruction.constructed(), hasSize(1));
            URL mock = myobjectMockedConstruction.constructed().get(0);
            verify(mock).openConnection();
        }
    }

}