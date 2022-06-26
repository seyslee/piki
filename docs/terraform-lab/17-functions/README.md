# 17. Terraform functions

터미널을 열고 테라폼 콘솔로 들어갑니다.

```bash
$ terraform console
>
```

테라폼 콘솔에서 다양한 함수들을 테스트해볼 수 있습니다.

## String

```bash
> "hello this is a string"
"hello this is a string"
```

## timestamp

```bash
> "The server launched at ${timestamp()}"
"The server launched at 2022-06-12T14:12:30Z"
```

## tolist

```bash
> tolist(["subnet-1", "subnet-2", "subnet-3"])
tolist([
  "subnet-1",
  "subnet-2",
  "subnet-3",
])
```

## slice

```bash
> slice(tolist(["subnet-1", "subnet-2", "subnet-3"]), 0, 2)
tolist([
  "subnet-1",
  "subnet-2",
])
```

리스트를 잘라서 두 개의 서브넷만 얻을 수 있습니다.

## join

```bash
> join(",", slice(tolist(["subnet-1", "subnet-2", "subnet-3"]), 0, 2))
"subnet-1,subnet-2"
```

리스트를 합쳐서 문자열로 만들 수 있습니다.

## toamp

```bash
> tomap({"ap-northeast-2" = "ami-1", "ap-northeast-1" = "ami-2"})
tomap({
  "ap-northeast-1" = "ami-2"
  "ap-northeast-2" = "ami-1"
})
```

명시적 유형 변환은 필요한 경우 자동으로 유형을 변환하기 떄문에 테라폼에서 거의 필요하지는 않습니다. [공식문서](https://www.terraform.io/language/functions/tomap)

```bash
> lookup(tomap({"ap-northeast-2" = "ami-1", "ap-northeast-1" = "ami-2"}), "ap-northeast-2")
"ami-1"
```

## index

리스트의 인덱스 값을 반환해줍니다.

```bash
> index(tolist(["subnet-1", "subnet-2", "subnet-3"]), "subnet-2")
1
> index(tolist(["subnet-1", "subnet-2", "subnet-3"]), "subnet-3")
2
```

## substr

문자열의 일부를 다시 가져옵니다.

```bash
> substr("abcd", 0, 1)
"a"
> substr("abcd", 0, 3)
"abc"
> substr("abcd", 3, 3)
"d"
> substr("abcd", 1, 3)
"bcd"
> substr("abcd", -1, 1)
"d"
> substr("abcd", -2, 1)
"c"
```

최고의 학습 방법은 조금씩 이걸 직접 사용해보는 겁니다!

모든걸 마치면 exit을 입력해서 테라폼 콘솔을 빠져나오면 됩니다.

```bash
> exit
```
