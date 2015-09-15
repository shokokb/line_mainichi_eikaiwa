###
### LINE毎日英会話->zuknowインポート用テキスト変換
### Authors::   shokokb
### 実行コマンド ruby convert.rb （対象のファイルパス）
### テスト環境：ruby 2.2.0p0 (2014-12-25 revision 49005) [x86_64-darwin13]
###
SCRIPT_FILENAME = 'convert.rb'
if ARGV.length == 1 then
  _filepath_original = ARGV[0]
  # _filepath_export = ARGV[0]
  _filepath_export = ARGV[0].sub(/\./, "_CONVERTED.")
  p "出力先: "+ _filepath_export
  begin
    item = ""
    File.open(_filepath_export,"w") { |file| file.puts "" }
    File.foreach(_filepath_original) do |line|
      # １問ずつ分割する。（日付で分割する。）
      if line.match(/\d{4}\/\d{2}\/\d{2}/) then

        # parts = item.split(/コレ英語で言えるかな？|解答例はこちらっ/);
        parts = item.gsub(/\r\n|\n+|\t|\"/, "").split(/\d{2}:\d{2}/);
        #p parts

        if parts[0] != nil and parts[1] != nil then
          question =
            parts[0] + " " +
            parts[1]
              .gsub(/^.*★/,"★")
              .gsub(/^.*A/, "A")
              .gsub(/一度自分で考えてみてね.*$/, "")
              .gsub(/カッコにあてはまる英文、わかるかな？.*$/, "")
        end

        if parts[2] != nil and not question.match("今週の復習") then
          answer = parts[2].gsub(/^.*解答例はこちらっ↓|次に流れる音声で(、*)発音もチェック！.*$/, "")
          p  "質問 " + question
          p "回答 " + answer
          File.open(_filepath_export,"a") { |file| file.puts question + "\t" + answer }
        end
        item = line
      else
        item = item + line
      end
    end
  rescue SystemCallError => e
    p %Q(class=[#{e.class}] message=[#{e.message}])
  end
else
  p "下記のコマンドで実行してください。"
  p "ruby %s %s" % [SCRIPT_FILENAME, "（対象のファイルパス）"]
end
