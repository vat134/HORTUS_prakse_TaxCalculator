page 80008 "Gemini dialogue"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group("User Input")
            {
                field("Input Text"; InputText)
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter text here.';
                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Send")
            {
                Caption = 'Send';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    ResponseText: Text[10000];
                begin
                    if InputText = '' then
                        Message('Please enter some text.')
                    else
                        ResponseText := MakeGeminiRequest(InputText);
                    Message(ResponseText);
                end;
            }
        }
    }

    local procedure MakeGeminiRequest(UserInput: Text[1000]): Text[10000]
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        JsonObject: JsonObject;
        JsonResponse: Text;
        APIUrl: Text;
        APIKey: Text;
        RequestBody: Text;
        RequestContent: HttpContent;
        ResponseText: Text;
        JsonToken: JsonToken;
        Headers: HttpHeaders;
        ModelVersion: Text[50];
        GeminiSettings: Record "Gemini Settings";
    begin
        APIKey := 'AIzaSyDvI4L-RsJQnHoUMN6onmt9SxB5KXBIBBY';
        ModelVersion := 'gemini-1.5-flash-latest';
        if GeminiSettings.FindFirst() then begin
            if GeminiSettings."API Key" = '' then
                Error('Setup is not completed. Please enter API Key.');
            if GeminiSettings."Model Version" = '' then
                Error('Setup is not completed. Please enter model version.');
            APIUrl := StrSubstNo('https://generativelanguage.googleapis.com/v1beta/models/%1:generateContent?key=%2', GeminiSettings."Model Version", GeminiSettings."API Key");
        end
        else
            Error('Setup is not completed. Please configure API settings.');

        RequestBody := StrSubstNo(
            '{' +
            '"contents": [{' +
            '"parts": [{' +
            '"text": "%1"' +
            '}]}]}',
            UserInput);

        RequestContent.WriteFrom(RequestBody);

        RequestContent.GetHeaders(Headers);
        Headers.Clear();
        Headers.Add('Content-Type', 'application/json');

        HttpRequestMessage.Method := 'POST';
        HttpRequestMessage.SetRequestUri(APIUrl);
        HttpRequestMessage.Content := RequestContent;

        HttpClient.Send(HttpRequestMessage, HttpResponseMessage);


        if HttpResponseMessage.IsSuccessStatusCode() then begin
            HttpResponseMessage.Content().ReadAs(JsonResponse);
            JsonObject.ReadFrom(JsonResponse);

            if JsonObject.Get('candidates', JsonToken) then begin
                if JsonToken.AsArray().Get(0, JsonToken) then begin
                    if JsonToken.AsObject().Get('content', JsonToken) then
                        if JsonToken.AsObject().Get('parts', JsonToken) then
                            if JsonToken.AsArray().Get(0, JsonToken) then
                                if JsonToken.AsObject().Get('text', JsonToken) then
                                    ResponseText := JsonToken.AsValue().AsText();
                end;
            end else
                Error('Failed to retrieve response from Gemini.');
        end else
            Error('HTTP request failed. Status: %1', HttpResponseMessage.HttpStatusCode);

        exit(ResponseText);
    end;


    var
        InputText: Text[1000];
}