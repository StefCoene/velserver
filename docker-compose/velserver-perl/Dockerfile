FROM perl:threaded as step1

ENV TZ=Europe/Brussels

RUN cpanm Hash::Merge

FROM step1 as step2
RUN cpanm Convert::Color

FROM step2 as step3
RUN cpanm CGI::Session

FROM step3 as step4
RUN cpanm DBD::SQLite

FROM step4 as step5
RUN cpanm CGI

FROM step5 as step6
RUN cpanm DBI

FROM step6 as step7
RUN cpanm HTTP::Request::Common

FROM step7 as step8
RUN cpanm LWP::UserAgent

FROM step8 as step9
RUN cpanm JSON::XS JSON

FROM step9 as step10
RUN cpanm IO::Socket::SSL
