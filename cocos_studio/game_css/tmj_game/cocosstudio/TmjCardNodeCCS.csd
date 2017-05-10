<GameFile>
  <PropertyGroup Name="TmjCardNodeCCS" Type="Node" ID="918ed5f1-5d85-4655-93af-4f323b8d8948" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="10" Speed="1.0000" ActivedAnimationName="animation1">
        <Timeline ActionTag="-1525785454" Property="Position">
          <PointFrame FrameIndex="1" X="0.0000" Y="9.0002">
            <EasingData Type="0" />
          </PointFrame>
        </Timeline>
        <Timeline ActionTag="-1525785454" Property="Scale">
          <ScaleFrame FrameIndex="1" X="1.0000" Y="1.0000">
            <EasingData Type="0" />
          </ScaleFrame>
        </Timeline>
        <Timeline ActionTag="-1525785454" Property="RotationSkew">
          <ScaleFrame FrameIndex="1" X="0.0000" Y="0.0000">
            <EasingData Type="0" />
          </ScaleFrame>
        </Timeline>
        <Timeline ActionTag="-1525785454" Property="VisibleForFrame">
          <BoolFrame FrameIndex="1" Tween="False" Value="True" />
          <BoolFrame FrameIndex="5" Tween="False" Value="False" />
          <BoolFrame FrameIndex="10" Tween="False" Value="False" />
        </Timeline>
        <Timeline ActionTag="-83963584" Property="VisibleForFrame">
          <BoolFrame FrameIndex="1" Tween="False" Value="False" />
          <BoolFrame FrameIndex="5" Tween="False" Value="True" />
          <BoolFrame FrameIndex="10" Tween="False" Value="False" />
        </Timeline>
        <Timeline ActionTag="-1276272270" Property="VisibleForFrame">
          <BoolFrame FrameIndex="1" Tween="False" Value="False" />
          <BoolFrame FrameIndex="5" Tween="False" Value="False" />
          <BoolFrame FrameIndex="10" Tween="False" Value="True" />
        </Timeline>
      </Animation>
      <AnimationList>
        <AnimationInfo Name="animation0" StartIndex="1" EndIndex="1">
          <RenderColor A="255" R="128" G="0" B="0" />
        </AnimationInfo>
        <AnimationInfo Name="animation2" StartIndex="10" EndIndex="10">
          <RenderColor A="255" R="255" G="239" B="213" />
        </AnimationInfo>
        <AnimationInfo Name="animation1" StartIndex="5" EndIndex="5">
          <RenderColor A="255" R="153" G="50" B="204" />
        </AnimationInfo>
      </AnimationList>
      <ObjectData Name="Node" Tag="5" ctype="GameNodeObjectData">
        <Size X="0.0000" Y="0.0000" />
        <Children>
          <AbstractNodeData Name="Image_back" ActionTag="-1525785454" VisibleForFrame="False" Tag="5" IconVisible="False" LeftMargin="-37.5000" RightMargin="-37.5000" TopMargin="-64.0002" BottomMargin="-45.9998" LeftEage="15" RightEage="15" TopEage="15" BottomEage="15" Scale9OriginX="15" Scale9OriginY="15" Scale9Width="45" Scale9Height="80" ctype="ImageViewObjectData">
            <Size X="75.0000" Y="110.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position Y="9.0002" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <FileData Type="Normal" Path="game_res/cards/mj_back.png" Plist="" />
          </AbstractNodeData>
          <AbstractNodeData Name="Image_card" ActionTag="-83963584" Tag="4" IconVisible="False" LeftMargin="-37.5000" RightMargin="-37.5000" TopMargin="-62.0000" BottomMargin="-48.0000" Scale9Enable="True" LeftEage="19" RightEage="19" TopEage="29" BottomEage="29" Scale9OriginX="19" Scale9OriginY="29" Scale9Width="37" Scale9Height="52" ctype="ImageViewObjectData">
            <Size X="75.0000" Y="110.0000" />
            <Children>
              <AbstractNodeData Name="Image_ting" ActionTag="-446201201" VisibleForFrame="False" Tag="244" IconVisible="False" LeftMargin="19.5041" RightMargin="-3.5041" TopMargin="-12.0329" BottomMargin="76.0329" LeftEage="19" RightEage="19" TopEage="15" BottomEage="15" Scale9OriginX="19" Scale9OriginY="15" Scale9Width="21" Scale9Height="16" ctype="ImageViewObjectData">
                <Size X="59.0000" Y="46.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="49.0041" Y="99.0329" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.6534" Y="0.9003" />
                <PreSize X="0.7867" Y="0.4182" />
                <FileData Type="Normal" Path="game_res/desk/tingtubiao.png" Plist="" />
              </AbstractNodeData>
              <AbstractNodeData Name="cardImg" ActionTag="-1488338273" Tag="6" IconVisible="False" LeftMargin="12.0000" RightMargin="15.0000" TopMargin="35.5000" BottomMargin="5.5000" LeftEage="13" RightEage="13" TopEage="18" BottomEage="18" Scale9OriginX="13" Scale9OriginY="18" Scale9Width="22" Scale9Height="33" ctype="ImageViewObjectData">
                <Size X="48.0000" Y="69.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="36.0000" Y="40.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.4800" Y="0.3636" />
                <PreSize X="0.6400" Y="0.6273" />
                <FileData Type="Normal" Path="game_res/cards/mj_1.png" Plist="" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position Y="7.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <FileData Type="Normal" Path="game_res/cards/mj_face.png" Plist="" />
          </AbstractNodeData>
          <AbstractNodeData Name="Image_card_1" ActionTag="-1276272270" VisibleForFrame="False" Tag="58" IconVisible="False" LeftMargin="-37.5000" RightMargin="-37.5000" TopMargin="-59.9557" BottomMargin="-50.0443" Scale9Enable="True" LeftEage="19" RightEage="19" TopEage="29" BottomEage="29" Scale9OriginX="19" Scale9OriginY="29" Scale9Width="37" Scale9Height="52" ctype="ImageViewObjectData">
            <Size X="75.0000" Y="110.0000" />
            <Children>
              <AbstractNodeData Name="cardImg_1" ActionTag="831507401" Tag="59" IconVisible="False" LeftMargin="12.0000" RightMargin="15.0000" TopMargin="35.4997" BottomMargin="5.5003" LeftEage="13" RightEage="13" TopEage="18" BottomEage="18" Scale9OriginX="13" Scale9OriginY="18" Scale9Width="22" Scale9Height="33" ctype="ImageViewObjectData">
                <Size X="48.0000" Y="69.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="36.0000" Y="40.0003" />
                <Scale ScaleX="1.0000" ScaleY="-1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.4800" Y="0.3636" />
                <PreSize X="0.6400" Y="0.6273" />
                <FileData Type="Normal" Path="game_res/cards/mj_1.png" Plist="" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position Y="4.9557" />
            <Scale ScaleX="1.0000" ScaleY="-1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <FileData Type="Normal" Path="game_res/cards/mj_face.png" Plist="" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>